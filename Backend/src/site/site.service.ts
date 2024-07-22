import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Site, SiteDocument } from './schemas/site.schema';
import { CreateSiteDto } from './dto/create-site.dto';

@Injectable()
export class SiteService {
    
    constructor(@InjectModel(Site.name) private siteModel: Model<SiteDocument>) {}

    async create(createSiteDto: CreateSiteDto): Promise<Site> {
        const site = new this.siteModel(createSiteDto);
        return site.save();
    }
    
    async findAll(): Promise<Site[]> {
        return this.siteModel.find().exec();
    }

    async findByName(name: string): Promise<Site> {
        const site = await this.siteModel.findOne({ name });
        if (!site) {
          throw new NotFoundException(`Site with name ${name} not found`);
        }
        return site;
    }
}
