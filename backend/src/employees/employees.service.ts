import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EmployeesService {
  constructor(private readonly prisma: PrismaService) {}

  createEmployee(data:any){
    return this.prisma.employee.create({data});
  }

  findAll(){
    return this.prisma.employee.findMany({
      include:{salaries:true,advances:true,debts:true},
      orderBy:{createdAt:'desc'}
    });
  }

  findOne(id:string){
    return this.prisma.employee.findUnique({
      where:{id},
      include:{salaries:true,advances:true,debts:true}
    });
  }

  addSalary(data:any){
    return this.prisma.salary.create({data});
  }

  addAdvance(data:any){
    return this.prisma.advance.create({data});
  }

  addDebt(data:any){
    return this.prisma.debt.create({data});
  }
}
