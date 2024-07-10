import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';
import * as moment from 'moment';


@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);
  
  constructor(@InjectModel(Order.name) private orderModel: Model<OrderDocument>, 
  private readonly jwtService: JwtService,) {}

  async create(createOrderDto: CreateOrderDto, userId: string): Promise<Order> {
    const { site, client, articles, ...rest } = createOrderDto;
  
    // Find the Site by name
    const foundSite = await this.orderModel.db.collection('sites').findOne({ name: site });
    if (!foundSite) {
      throw new NotFoundException(`Site with name ${site} not found`);
    }
    this.logger.debug(`Found site: ${JSON.stringify(foundSite)}`);
  
    // Find the Client by name
    const foundClient = await this.orderModel.db.collection('clients').findOne({ name: client });
    if (!foundClient) {
      throw new NotFoundException(`Client with name ${client} not found`);
    }
    this.logger.debug(`Found client: ${JSON.stringify(foundClient)}`);
  
    // Transform article names to ObjectIds
    const transformedArticles = await Promise.all(
      articles.map(async articleOrder => {
        const foundArticle = await this.orderModel.db.collection('articles').findOne({ name: articleOrder.article });
        if (!foundArticle) {
          throw new NotFoundException(`Article with name ${articleOrder.article} not found`);
        }
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
      user: userId,
    });
  
    await order.save();
    return order;
  }
  


  async findAll(userId: string): Promise<any[]> {
      const orders = await this.orderModel
        .find({ user: userId })
        .populate('client', 'name')
        .populate('site', 'name')
        .populate('articles.article', 'name')
        .lean()
        .exec();
  
      // Transform the output to only include names instead of full objects
      return orders.map(order => ({
        ...order,
        client: (order.client as any).name,
        site: (order.site as any).name,
        dateCommande: moment(order.dateCommande).format('YYYY-MM-DD'),
        dateLivraison: moment(order.dateLivraison).format('YYYY-MM-DD'),
        articles: order.articles.map(articleOrder => ({
          name: (articleOrder.article as any).name,
          quantity: articleOrder.quantity,
          unit: articleOrder.unit,
        })),
      }));
  }
  
  

  async findOne(id: string): Promise<Order> {
    const order = await this.orderModel.findById(id).exec();
    if (!order) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }
    return order;
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

  async findByEtatCommande(etatCommande: string, userId: string): Promise<any[]> {
    const orders = await this.orderModel
      .find({ etatCommande, user: userId })
      .populate('client', 'name')
      .populate('site', 'name')
      .populate('articles.article', 'name')
      .lean()
      .exec();
  
    // Transform the output to only include names instead of full objects
    return orders.map(order => ({
      ...order,
      client: (order.client as any).name,
      site: (order.site as any).name,
      dateCommande: moment(order.dateCommande).format('YYYY-MM-DD'),
      dateLivraison: moment(order.dateLivraison).format('YYYY-MM-DD'),
      articles: order.articles.map(articleOrder => ({
        name: (articleOrder.article as any).name,
        quantity: articleOrder.quantity,
        unit: articleOrder.unit,
      })),
    }));
  }


}
