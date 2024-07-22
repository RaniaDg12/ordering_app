import { Module } from '@nestjs/common';
import { SiteController } from './site.controller';
import { SiteService } from './site.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Site, SiteSchema } from './schemas/site.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Site.name, schema: SiteSchema },]),
],
  controllers: [SiteController],
  providers: [SiteService]
})
export class SiteModule {}
