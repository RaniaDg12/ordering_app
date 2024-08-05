import { Controller, Get, Post, Body, Patch, Param, Delete, Req, UseGuards, UnauthorizedException, Logger, Put } from '@nestjs/common';
import { ArticleService } from './article.service';
import { Article } from './schemas/article.schema';
import { CreateArticleDto } from './dto/create-article.dto';
import { UpdateArticleDto } from './dto/update-article.dto';

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

    @Put('update/:id')
    async update(@Param('id') id: string, @Body() updateArticleDto: UpdateArticleDto): Promise<Article> {
        const updatedArticle: Partial<Article> = { ...updateArticleDto, _id: id };
        console.log('Received update request for ID:', id);
        console.log('Update data:', updateArticleDto);
        return this.articleService.update(updatedArticle as Article);
    }

    @Delete('delete/:id')
    async delete(@Param('id') id: string): Promise<Article> {
      console.log('Received delete request for ID:', id);
      return this.articleService.delete(id);
    }
}
