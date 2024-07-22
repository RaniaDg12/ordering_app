import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { ClientService } from 'src/client/client.service';
import { ClientController } from 'src/client/client.controller';
import { SiteService } from 'src/site/site.service';
import { SiteController } from 'src/site/site.controller';
import { ArticleService } from 'src/article/article.service';
import { ArticleController } from 'src/article/article.controller';
import { AuthModule } from '../auth/auth.module'; 
import { ArticleModule } from 'src/article/article.module';
import { Order, OrderSchema } from './schemas/order.schema';
import { Site, SiteSchema } from 'src/site/schemas/site.schema';
import { Client, ClientSchema } from 'src/client/schemas/client.schema';
import { Article, ArticleSchema } from 'src/article/schemas/article.schema';
import { ArticleOrder, ArticleOrderSchema } from 'src/article/schemas/articleOrder.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Order.name, schema: OrderSchema },
    { name: Site.name, schema: SiteSchema },
    { name: Client.name, schema: ClientSchema },
    { name: Article.name, schema: ArticleSchema },
    { name: ArticleOrder.name, schema: ArticleOrderSchema },
  ]),
  AuthModule,ArticleModule],
  controllers: [OrderController, ArticleController, ClientController, SiteController],
  providers: [OrderService, ArticleService, ClientService, SiteService],
})
export class OrderModule {}
