import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { AuthModule } from '../auth/auth.module'; 
import { Order, OrderSchema } from './schemas/order.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Order.name, schema: OrderSchema }]),
  AuthModule,],
  controllers: [OrderController],
  providers: [OrderService],
})
export class OrderModule {}
