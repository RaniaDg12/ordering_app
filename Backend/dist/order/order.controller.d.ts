import { OrderService } from './order.service';
import { Query as ExpressQuery } from 'express-serve-static-core';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './schemas/order.schema';
export declare class OrderController {
    private readonly orderService;
    constructor(orderService: OrderService);
    create(createOrderDto: CreateOrderDto, req: any): Promise<Order>;
    findAll(query: ExpressQuery): Promise<Order[]>;
    findOne(id: string): Promise<Order>;
    update(id: string, updateOrderDto: UpdateOrderDto): Promise<Order>;
    remove(id: string): Promise<Order>;
    findByClient(clientId: string): Promise<Order[]>;
    findByEtatCommande(etatCommande: string): Promise<Order[]>;
}
