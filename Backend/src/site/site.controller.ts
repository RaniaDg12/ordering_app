import { Body, Controller, Get, Logger, Param, Post, Put, Delete } from '@nestjs/common';
import { SiteService } from './site.service';
import { Site, SiteDocument } from './schemas/site.schema';
import { CreateSiteDto } from './dto/create-site.dto';
import { UpdateSiteDto } from './dto/update-site.dto';

@Controller('sites')
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

    @Put('update/:id')
    async update(@Param('id') id: string, @Body() updateSiteDto: UpdateSiteDto): Promise<Site> {
        const updatedSite: Partial<Site> = { ...updateSiteDto, _id: id };
        console.log('Received update request for ID:', id);
        console.log('Update data:', updateSiteDto);
        return this.siteService.update(updatedSite as Site);
    }

    @Delete('delete/:id')
    async delete(@Param('id') id: string): Promise<Site> {
      console.log('Received delete request for ID:', id);
      return this.siteService.delete(id);
    }

}
