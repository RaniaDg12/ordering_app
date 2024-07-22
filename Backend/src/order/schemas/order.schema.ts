import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';
import { ArticleOrder } from 'src/article/schemas/articleOrder.schema';
import { User } from 'src/auth/schemas/user.schema';

export type OrderDocument = Order & Document;

export enum Priority {
    HIGH = 'Eleve',
    MEDIUM = 'Moyenne',
    LOW = 'Faible',
}



@Schema()
export class Order {
  @Prop({ required: true })
  dateCommande: string;

  @Prop({ required: true })
  dateLivraison: string;

  @Prop({ required: true, default: 'Encours' })
  etatCommande: string;

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
