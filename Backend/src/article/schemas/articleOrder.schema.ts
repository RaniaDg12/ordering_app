import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import mongoose, { Document } from 'mongoose';
import { Article } from './article.schema';

export type ArticleOrderDocument = ArticleOrder & Document;

@Schema()
export class ArticleOrder {

  @Prop({ type: mongoose.Schema.Types.ObjectId, ref: 'Article', required: true })
  article: mongoose.Schema.Types.ObjectId;

  @Prop({ required: true })
  quantity: number;

  @Prop({ required: true })
  unit: string;
}

export const ArticleOrderSchema = SchemaFactory.createForClass(ArticleOrder);