import { IsNotEmpty, IsString, } from 'class-validator';


export class CreateSiteDto {
  @IsString()
  @IsNotEmpty()
  code: string; 

  @IsString()
  @IsNotEmpty()
  name: string; 

}