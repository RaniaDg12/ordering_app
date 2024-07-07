import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';
import { User } from 'src/auth/schemas/user.schema';

export type OrderDocument = Order & Document;

export enum Priority {
    HIGH = 'Eleve',
    MEDIUM = 'Moyenne',
    LOW = 'Faible',
}

export enum Status {
    SEND = 'Termine',
    PROGRESS = 'En cours',
}

@Schema()
export class ArticleOrder {
  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'Article', required: true })
  article: mongoose.Schema.Types.ObjectId;

  @Prop({ required: true })
  quantity: number;

  @Prop({ required: true })
  unit: string;
}

@Schema()
export class Order {
  @Prop({ required: true })
  dateCommande: string;

  @Prop({ required: true })
  dateLivraison: string;

  @Prop({ required: true })
  etatCommande: Status;

  @Prop({ required: true })
  priority: Priority;

  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true })
  user: User;

  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'Client', required: true })
  client: mongoose.Schema.Types.ObjectId;

  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'Site', required: true })
  site: mongoose.Schema.Types.ObjectId;

  @Prop({ type: [ArticleOrder], required: true })
  articles: ArticleOrder[];

  @Prop()
  observation: string;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
export const ArticleOrderSchema = SchemaFactory.createForClass(ArticleOrder);
