import { Controller,Post,Get,Patch,Param,Body,Put } from '@nestjs/common';
import { BreadTypeService } from './bread-type.service';

@Controller('bread-type')
export class BreadTypeController {
 constructor(private service:BreadTypeService){}

 @Post()
 create(@Body() data:any){
  return this.service.create(data);
 }

 @Get()
 findAll(){
  return this.service.findAll();
 }

 @Put(':id')
 update(@Param('id') id:string,@Body() data:any){
  return this.service.update(id,data);
 }
}
