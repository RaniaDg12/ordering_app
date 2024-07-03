import { Model } from 'mongoose';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';
import { JwtService } from '@nestjs/jwt';
export declare class OrderService {
    private orderModel;
    private readonly jwtService;
    constructor(orderModel: Model<OrderDocument>, jwtService: JwtService);
    create(createOrderDto: CreateOrderDto, userId: string): Promise<Order>;
    findAll(query: any): Promise<Order[]>;
    findOne(id: string): Promise<Order>;
    update(id: string, updateOrderDto: UpdateOrderDto): Promise<Order>;
    remove(id: string): Promise<Order>;
    findByClient(clientId: string): Promise<Order[]>;
    findByEtatCommande(etatCommande: string): Promise<Order[]>;
}
