import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order, OrderDocument } from './schemas/order.schema';
export declare class OrderService {
    private orderModel;
    private readonly jwtService;
    private readonly logger;
    constructor(orderModel: Model<OrderDocument>, jwtService: JwtService);
    create(createOrderDto: CreateOrderDto, userId: string): Promise<Order>;
    findAll(userId: string): Promise<any[]>;
    findOne(id: string, userId: string): Promise<any>;
    update(id: string, updateOrderDto: UpdateOrderDto): Promise<Order>;
    remove(id: string): Promise<Order>;
    findByEtatCommande(etatCommande: string, userId: string): Promise<any[]>;
}
