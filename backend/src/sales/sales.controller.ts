import { CreateSaleDto } from './dto/create-sale.dto';
import { Controller,Get,Post,Body,Param } from '@nestjs/common';
import { SalesService } from './sales.service';

@Controller('sales')
export class SalesController{

constructor(private service:SalesService){}

@Get()
findAll(){
 return this.service.findAll();
}

  @Get('seller-report/:employeeId')
  sellerReport(@Param('employeeId') employeeId:string){
    return this.service.sellerReport(employeeId);
  }

@Post()
create(@Body() data:CreateSaleDto){
 return this.service.create(data);
}

}
