import { IsDate, IsNotEmpty, IsString, IsEnum, IsArray, ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { Priority, Status } from '../schemas/order.schema';

class CreateArticleOrderDto {
  @IsNotEmpty()
  article: string; 

  @IsNotEmpty()
  quantity: number;

  @IsString()
  @IsNotEmpty()
  unit: string;
}

export class CreateOrderDto {
  @IsDate()
  @IsNotEmpty()
  @Type(() => Date)
  dateCommande: Date;

  @IsDate()
  @IsNotEmpty()
  @Type(() => Date)
  dateLivraison: Date;

  @IsEnum(Status)
  @IsNotEmpty()
  etatCommande: string;

  @IsEnum(Priority)
  @IsNotEmpty()
  priority: Priority;

  @IsNotEmpty()
  client: string; 
  
  @IsString()
  @IsNotEmpty()
  site: string; 

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateArticleOrderDto)
  articles: CreateArticleOrderDto[];

  @IsString()
  @IsOptional()
  observation?: string;
}
