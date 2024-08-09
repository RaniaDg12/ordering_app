import { IsString } from 'class-validator';

export class UpdateUserDto {
  @IsString()
  code: string;

  @IsString()
  name: string;

  @IsString()
  appareil: string;

}
