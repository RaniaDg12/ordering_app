import { IsDate, IsNotEmpty, IsString, IsEnum, IsArray, ValidateNested, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';
import { Priority} from '../schemas/order.schema';
import { CreateArticleOrderDto } from 'src/article/dto/create-articleorder.dto';


export class CreateOrderDto {
  @IsNotEmpty()
  dateCommande: string;

  @IsNotEmpty()
  dateLivraison: string;

  @IsString()
  @IsOptional()  
  etatCommande?: string;

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
