import { Controller, Post, Get, Put, Body, Param } from '@nestjs/common';
import { SellerDebtService } from './seller-debt.service';

@Controller('seller-debt')
export class SellerDebtController {

constructor(
private service:SellerDebtService
){}


@Post()
create(@Body() body:any){
return this.service.create(body);
}


@Get('open')
open(){
return this.service.openDebts();
}


@Get('seller/:id')
seller(@Param('id') id:string){
return this.service.sellerDebts(id);
}


@Post(':id/payment')
payment(
@Param('id') id:string,
@Body() body:any
){
return this.service.payment(id,body.amount);
}


@Put(':id/approve')
approve(
@Param('id') id:string,
@Body() body:any
){
return this.service.approve(id,body.manager);
}

}
