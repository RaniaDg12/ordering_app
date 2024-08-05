import { IsString } from 'class-validator';

export class UpdateSiteDto {
  @IsString()
  code: string;

  @IsString()
  name: string;

}
