import { IsString } from 'class-validator';

export class UpdateArticleDto {
  @IsString()
  name: string;

}
