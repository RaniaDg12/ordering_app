import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Article, ArticleDocument } from './schemas/article.schema';
import { CreateArticleDto } from './dto/create-article.dto';

@Injectable()
export class ArticleService {

    constructor(@InjectModel(Article.name) private articleModel: Model<ArticleDocument>) {}

    async create(createArticleDto: CreateArticleDto): Promise<Article> {
        const article = new this.articleModel(createArticleDto);
        return article.save();
    }
    
    async findAll(): Promise<Article[]> {
        return this.articleModel.find().exec();
    }

    async findByName(name: string): Promise<Article> {
        const article = await this.articleModel.findOne({ name });
        if (!article) {
          throw new NotFoundException(`Article with name ${name} not found`);
        }
        return article;
      }
}
