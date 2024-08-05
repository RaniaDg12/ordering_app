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

    async update(site: Partial<Site>): Promise<Site> {
        console.log('Updating site with data:', site);
        const updatedSite = await this.siteModel.findByIdAndUpdate(site._id, site, { new: true });
        console.log('Updated site:', updatedSite);
        return updatedSite;
    }

    async delete(id: string): Promise<Site> {
        console.log(`Deleting site with ID: ${id}`);
        const deletedSite = await this.siteModel.findByIdAndDelete(id);
        console.log('Deleted site:', deletedSite);
        return deletedSite;
    } 

}
