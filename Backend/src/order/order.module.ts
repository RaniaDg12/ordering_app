import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { AuthModule } from '../auth/auth.module'; 
import { Order, OrderSchema } from './schemas/order.schema';
import { Site, SiteSchema } from './schemas/order.schema';
import { Client, ClientSchema } from './schemas/order.schema';
import { Article, ArticleSchema } from './schemas/order.schema';
import { ArticleOrder, ArticleOrderSchema } from './schemas/order.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Order.name, schema: OrderSchema },
    { name: Site.name, schema: SiteSchema },
    { name: Client.name, schema: ClientSchema },
    { name: Article.name, schema: ArticleSchema },
    { name: ArticleOrder.name, schema: ArticleOrderSchema },
  ]),
  AuthModule,],
  controllers: [OrderController],
  providers: [OrderService],
})
export class OrderModule {}
