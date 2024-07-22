import { IsNotEmpty, IsString, } from 'class-validator';


export class CreateArticleDto {
  @IsString()
  @IsNotEmpty()
  name: string; 

}