import { IsNotEmpty, IsString, } from 'class-validator';


export class CreateArticleOrderDto {
  @IsNotEmpty()
  article: string; 

  @IsNotEmpty()
  quantity: number;

  @IsString()
  @IsNotEmpty()
  unit: string;
}