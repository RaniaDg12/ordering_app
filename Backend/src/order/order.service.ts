import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';
import { JwtService } from '@nestjs/jwt';
import { User } from 'src/auth/schemas/user.schema';


@Injectable()
export class OrderService {
  constructor(@InjectModel(Order.name) private orderModel: Model<OrderDocument>, 
  private readonly jwtService: JwtService,) {}

  async create(createOrderDto: CreateOrderDto, userId: string): Promise<Order> {
    const createdOrder = new this.orderModel({
      ...createOrderDto,
      User: userId,});
    return createdOrder.save();
  }

  async findAll(query: any): Promise<Order[]> {
    return this.orderModel.find(query).exec();
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

  async findByClient(clientId: string): Promise<Order[]> {
    return this.orderModel.find({ client: clientId }).exec();
  }

  async findByEtatCommande(etatCommande: string): Promise<Order[]> {
    return this.orderModel.find({ etatCommande }).exec();
  }
}
