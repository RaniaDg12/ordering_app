import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule } from '@nestjs/config';
import { PassportModule } from '@nestjs/passport';
import { env } from 'process';
import { config } from 'dotenv';
import { OrderModule } from './order/order.module';
import { ArticleModule } from './article/article.module';
import { SiteModule } from './site/site.module';
import { ClientModule } from './client/client.module';
config();

@Module({
  imports: [PassportModule.register({ defaultStrategy: 'jwt' }),
    ConfigModule.forRoot({
      envFilePath: '.env',
      isGlobal: true,}
    ),
  MongooseModule.forRoot('mongodb://localhost:27017/agrimed'),
  AuthModule,JwtModule, OrderModule, ArticleModule, SiteModule, ClientModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
