import { CreateInventoryDto } from './dto/create-inventory.dto';
import { Controller,Get,Post,Patch,Param,Body } from '@nestjs/common';
import { InventoryService } from './inventory.service';

@Controller('inventory')
export class InventoryController {

  constructor(private service:InventoryService){}


  @Get()
  findAll(){
    return this.service.findAll();
  }


  @Post()
  create(@Body() data:CreateInventoryDto){
    return this.service.create(data);
  }


  @Patch(':id')
  update(
    @Param('id') id:string,
    @Body() data:CreateInventoryDto
  ){
    return this.service.update(id,data);
  }


  @Get('low-stock')
  lowStock(){
    return this.service.lowStock();
  }


  @Get('report')
  report(){
    return this.service.report();
  }


  @Post('merge-flour')
  mergeFlour(){
    return this.service.mergeFlourInventory();
  }

}
