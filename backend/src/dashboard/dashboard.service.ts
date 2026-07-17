import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DashboardService {
constructor(private prisma:PrismaService){}

async getDashboard(){
const sales=await this.prisma.sale.aggregate({_sum:{total:true}});
const expenses=await this.prisma.expense.aggregate({_sum:{amount:true}});
const production=await this.prisma.productionBatch.aggregate({_sum:{breadCount:true}});
return {sales:sales._sum.total??0,expenses:expenses._sum.amount??0,production:production._sum.breadCount??0,profit:(sales._sum.total??0)-(expenses._sum.amount??0)};
}

async getDailyReport(){
const d=new Date(); d.setHours(0,0,0,0);
const n=new Date(d); n.setDate(n.getDate()+1);
const sales=await this.prisma.sale.aggregate({where:{createdAt:{gte:d,lt:n}},_sum:{total:true}});
const expenses=await this.prisma.expense.aggregate({where:{createdAt:{gte:d,lt:n}},_sum:{amount:true}});
const production=await this.prisma.productionBatch.aggregate({where:{createdAt:{gte:d,lt:n}},_sum:{breadCount:true}});
return {date:d,production:production._sum.breadCount??0,sales:sales._sum.total??0,expenses:expenses._sum.amount??0,profit:(sales._sum.total??0)-(expenses._sum.amount??0)};
}

async getWeeklyReport(){
const days:any[]=[];
for(let i=6;i>=0;i--){
const d=new Date(); d.setDate(d.getDate()-i);
const n=new Date(d); n.setDate(n.getDate()+1);
const sales=await this.prisma.sale.aggregate({where:{createdAt:{gte:d,lt:n}},_sum:{total:true}});
const production=await this.prisma.productionBatch.aggregate({where:{createdAt:{gte:d,lt:n}},_sum:{breadCount:true}});
days.push({date:d.toISOString().substring(0,10),sales:sales._sum.total??0,production:production._sum.breadCount??0});
}
return days;
}
}
