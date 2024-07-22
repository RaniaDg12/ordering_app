import { Controller, Get, Post, Body, Patch, Param, Delete, Req, UseGuards, UnauthorizedException, Logger } from '@nestjs/common';
import { ArticleService } from './article.service';
import { Article } from './schemas/article.schema';
import { CreateArticleDto } from './dto/create-article.dto';

@Controller('articles')
export class ArticleController {
    private readonly logger = new Logger(ArticleController.name);
  
    constructor(private readonly articleService: ArticleService) {}
    
    @Post()
    async create(@Body() CreateArticleDto: CreateArticleDto): Promise<Article> {
        return this.articleService.create(CreateArticleDto);
    }

    @Get()
    async findAll(): Promise<Article[]> {
        return this.articleService.findAll();
    }

    @Get(':name')
    async findOne(@Param('name') name: string): Promise<any> {
      return this.articleService.findByName(name);
    }
}
