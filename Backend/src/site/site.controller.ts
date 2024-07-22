import { Body, Controller, Get, Logger, Param, Post } from '@nestjs/common';
import { SiteService } from './site.service';
import { Site, SiteDocument } from './schemas/site.schema';
import { CreateSiteDto } from './dto/create-site.dto';

@Controller('site')
export class SiteController {

    private readonly logger = new Logger(SiteController.name);
  
    constructor(private readonly siteService: SiteService) {}
    
    @Post()
    async create(@Body() CreateSiteDto: CreateSiteDto): Promise<Site> {
        return this.siteService.create(CreateSiteDto);
    }

    @Get()
    async findAll(): Promise<Site[]> {
        return this.siteService.findAll();
    }

    @Get(':name')
    async findOne(@Param('name') name: string): Promise<any> {
      return this.siteService.findByName(name);
    }
}
