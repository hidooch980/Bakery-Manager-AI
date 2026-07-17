import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BreadTypeService {
 constructor(private prisma:PrismaService){}

 create(data:any){
  return this.prisma.breadType.create({data});
 }

 findAll(){
  return this.prisma.breadType.findMany({orderBy:{createdAt:'desc'}});
 }

 update(id:string,data:any){
  return this.prisma.breadType.update({where:{id},data});
 }

 toggle(id:string){
  return this.prisma.breadType.update({
   where:{id},
   data:{active:{set:false}}
  });
 }
}
