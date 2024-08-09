import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model, Query} from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';
import { ArticleService } from 'src/article/article.service';
import { ClientService } from 'src/client/client.service';
import { SiteService } from 'src/site/site.service';
import * as moment from 'moment';
import { Site } from 'src/site/schemas/site.schema';
import { User } from 'src/auth/schemas/user.schema';



@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);
  
  constructor(
    @InjectModel(Order.name) private orderModel: Model<OrderDocument>, 
    @InjectModel(Site.name) private siteModel: Model<Site>,
    @InjectModel(User.name) private userModel: Model<User>,
  private readonly jwtService: JwtService,
  private readonly articleService: ArticleService,
  private readonly siteService: SiteService,
  private readonly clientService: ClientService,) {}


  private formatDate(date: string): string {
    return moment(date, 'YYYY-MM-DD').format('YYYY-MM-DD');
  }

  private transformOrder(order: any): any {
    return {
      ...order,
      client: order.client ? (order.client as any).name : null,
      site: order.site ? (order.site as any).name : null,
      user: order.user ? (order.user as any).name : null,
      dateCommande: this.formatDate(order.dateCommande),
      dateLivraison: this.formatDate(order.dateLivraison),
      articles: order.articles.map(articleOrder => ({
        name: articleOrder.article ? (articleOrder.article as any).name : null,
        quantity: articleOrder.quantity,
        unit: articleOrder.unit,
      })),
    };
  }

  private async populateOrderFields(query: Query<any, any>): Promise<any> {
    return query
      .populate('client', 'name')
      .populate('site', 'name')
      .populate('articles.article', 'name')
      .populate('user', 'name') 
      .lean()
      .exec();
  }

  

  async create(createOrderDto: CreateOrderDto, userId: string): Promise<Order> {
    const { site, client, articles, dateCommande, dateLivraison, etatCommande = 'Envoye', ...rest } = createOrderDto;
  
    // Format the dates using the formatDate method
    const formattedDateCommande = this.formatDate(dateCommande);
    const formattedDateLivraison = this.formatDate(dateLivraison);
  
    // Find the Site by name
    const foundSite = await this.siteService.findByName(site);
  
    // Find the Client by name
    const foundClient = await this.clientService.findByName(client);
  
    // Transform article names to ObjectIds
    const transformedArticles = await Promise.all(
      articles.map(async articleOrder => {
        const foundArticle = await this.articleService.findByName(articleOrder.article);
        return {
          article: foundArticle._id,
          quantity: articleOrder.quantity,
          unit: articleOrder.unit,
        };
      })
    );
  
    // Create the order with the transformed articles array and formatted dates
    const order = new this.orderModel({
      ...rest,
      site: foundSite._id,
      client: foundClient._id,
      articles: transformedArticles,
      etatCommande: 'Envoye',
      user: userId,
      dateCommande: formattedDateCommande,
      dateLivraison: formattedDateLivraison,
    });
  
    await order.save();
    return order;
}
  

  async findAll(userId: string): Promise<any[]> {
    const orders = await this.populateOrderFields(this.orderModel.find({ user: userId }));
  
      // Transform the output to only include names instead of full objects
      return orders.map(order => this.transformOrder(order));
  }
  

  async findOne(id: string, userId: string): Promise<any> {
    // Check if the id is a valid ObjectId
    const isValidObjectId = mongoose.Types.ObjectId.isValid(id);
    if (!isValidObjectId) {
      throw new NotFoundException(`Invalid ID provided: ${id}`);
    }
  
    // Find the order by id and populate the necessary fields
    const order = await this.orderModel
      .findById(id)
      .populate('client', 'name')
      .populate('site', 'name')
      .populate('articles.article', 'name')
      .lean()
      .exec();
  
    if (!order) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
  
    // Transform the order to the desired format
    return this.transformOrder(order);
  }


  async findByEtatCommande(etatCommande: string, userId: string): Promise<any[]> {
    const orders = await this.orderModel
      .find({ etatCommande, user: userId })
      .populate('client', 'name')
      .populate('site', 'name')
      .populate('articles.article', 'name')
      .lean()
      .exec();
  
    // Transform the output to only include names instead of full objects
    return orders.map(order => this.transformOrder(order));
  }



  async update(id: string, updateOrderDto: UpdateOrderDto): Promise<Order> {
    const existingOrder = await this.orderModel.findByIdAndUpdate(id, updateOrderDto, { new: true }).exec();
    if (!existingOrder) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return existingOrder;
  }


  async remove(id: string): Promise<Order> {
    const deletedOrder = await this.orderModel.findByIdAndDelete(id).exec();
    if (!deletedOrder) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return deletedOrder;
  }


  async findAllOrders(): Promise<Order[]> {
    const orders = await this.populateOrderFields(this.orderModel.find());
  
    // Transform the output to only include names instead of full objects
    return orders.map(order => this.transformOrder(order));
  }


  async countAll(): Promise<number> {
    return this.orderModel.countDocuments().exec();
  }

  async countBySiteName(siteName: string): Promise<number> {
    const site = await this.siteModel.findOne({ name: siteName }).exec();
    if (!site) {
      throw new Error(`Site with name ${siteName} not found`);
    }
    return this.orderModel.countDocuments({ site: site._id }).exec();
  }


  async countByUserName(userName: string): Promise<number> {
    const user = await this.userModel.findOne({ name: userName }).exec();
    if (!user) {
      throw new Error(`user with name ${userName} not found`);
    }
    return this.orderModel.countDocuments({ user: user._id }).exec();
  }

  async countByDateCommande(dateCommande: string): Promise<number> {
    console.log('Received dateCommande:', dateCommande);

    // Format the date to ensure it is in the correct format
    const formattedDate = this.formatDate(dateCommande);
    console.log('Formated formattedDate:', formattedDate);

    // Count documents for the specific date
    const count = await this.orderModel.countDocuments({
        dateCommande: formattedDate
    }).exec();

    console.log('Order count:', count);
    return count;
}
  


 
async countByDateRange(): Promise<{ [date: string]: number }> {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1; // Months are 0-based in JavaScript

  const counts: { [date: string]: number } = {};

  // Iterate through each day of the month
  for (let day = 1; day <= new Date(year, month, 0).getDate(); day++) {
      // Format the date as YYYY-M-D
      const formattedMonth = month < 10 ? `0${month}` : month; // Ensure month is two digits
      const formattedDay = day < 10 ? `0${day}` : day; // Ensure day is two digits
      const date = `${year}-${formattedMonth}-${formattedDay}`;

      // Format the date for querying
      const formattedDate = this.formatDate(date);

      console.log('Query Date:', formattedDate); // Log the date being queried

      // Count documents for the specific date
      const count = await this.countByDateCommande(formattedDate); // Reuse countByDateCommande

      counts[formattedDate] = count;
  }

  console.log('Daily Order Counts:', counts);
  return counts;
}






  

  
  
  
  
  
  
  



  
  
  
}



