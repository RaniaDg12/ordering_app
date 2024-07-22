import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';
import { Order } from './schemas/order.schema';
export declare class OrderController {
    private readonly orderService;
    private readonly logger;
    constructor(orderService: OrderService);
    create(createOrderDto: CreateOrderDto, req: any): Promise<Order>;
    findAll(req: any): Promise<Order[]>;
    findOne(id: string, req: any): Promise<any>;
    update(id: string, updateOrderDto: UpdateOrderDto): Promise<Order>;
    remove(id: string): Promise<Order>;
    findByEtatCommande(etatCommande: string, req: any): Promise<Order[]>;
}
