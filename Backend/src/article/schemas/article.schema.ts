import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import {Document } from 'mongoose';

export type ArticleDocument = Article & Document;

@Schema()
export class Article extends Document {
  
  @Prop({ required: true })
  name: string;
}

export const ArticleSchema = SchemaFactory.createForClass(Article);