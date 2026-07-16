import { Controller,Get,Post,Body } from '@nestjs/common';
import { SalesService } from './sales.service';

@Controller('sales')
export class SalesController{

constructor(private service:SalesService){}

@Get()
findAll(){
 return this.service.findAll();
}

@Post()
create(@Body() data:any){
 return this.service.create(data);
}

}
