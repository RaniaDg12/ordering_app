import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';


@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);
  
  constructor(@InjectModel(Order.name) private orderModel: Model<OrderDocument>, 
  private readonly jwtService: JwtService,) {}

  async create(createOrderDto: CreateOrderDto, userId: string): Promise<Order> {
    const { site, client, articles, ...rest } = createOrderDto;

    this.logger.debug(`Creating order with site: ${site}, client: ${client}, and articles: ${JSON.stringify(articles)}`);

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
        this.logger.debug(`Found article: ${JSON.stringify(foundArticle)}`);
        return {
          ...articleOrder,
          article: foundArticle._id,
        };
      })
    );

    this.logger.debug(`Transformed articles: ${JSON.stringify(transformedArticles)}`);

    const order = new this.orderModel({
      ...rest,
      site: foundSite._id,
      client: foundClient._id,
      articles: transformedArticles,
      user: userId,
    });

    this.logger.debug(`Final order object: ${JSON.stringify(order)}`);

    return order.save();
  }


  async findAll(userId: string): Promise<Order[]> {
    return this.orderModel.find({ user: userId }).exec();
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

  async findByEtatCommande(etatCommande: string, userId: string): Promise<Order[]> {
    return this.orderModel.find({ etatCommande, user: userId  }).exec();
  }

}
