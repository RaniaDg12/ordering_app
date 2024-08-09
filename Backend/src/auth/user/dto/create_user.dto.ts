import { IsNotEmpty, IsString, MinLength, } from 'class-validator';


export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  code: string; 

  @IsString()
  @IsNotEmpty()
  name: string; 

  @IsString()
  @IsNotEmpty()
  appareil: string;

  @IsNotEmpty()
  @IsString()
  @MinLength(6)
  readonly password: string;

}