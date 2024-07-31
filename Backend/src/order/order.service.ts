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



@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);
  
  constructor(@InjectModel(Order.name) private orderModel: Model<OrderDocument>, 
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
      client: (order.client as any).name,
      site: (order.site as any).name,
      dateCommande: this.formatDate(order.dateCommande),
      dateLivraison: this.formatDate(order.dateLivraison),
      articles: order.articles.map(articleOrder => ({
        name: (articleOrder.article as any).name,
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
      .lean()
      .exec();
  }

  

  async create(createOrderDto: CreateOrderDto, userId: string): Promise<Order> {
    const { site, client, articles, etatCommande = 'Envoye', ...rest } = createOrderDto;
  
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
  
    // Create the order with the transformed articles array
    const order = new this.orderModel({
      ...rest,
      site: foundSite._id,
      client: foundClient._id,
      articles: transformedArticles,
      etatCommande: 'Envoye',
      user: userId,
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

  

}



