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
      include:{
        salaries:true,
        advances:true,
        debts:true,
        naninoComparisons:true
      },
      orderBy:{createdAt:'desc'}
    });
  }

  findOne(id:string){
    return this.prisma.employee.findUnique({
      where:{id},
      include:{
        salaries:true,
        advances:true,
        debts:true,
        naninoComparisons:true
      }
    });
  }

  async performance(id:string){
    const nanino = await this.prisma.naninoComparison.aggregate({
      where:{employeeId:id},
      _sum:{
        sellingDoughCount:true,
        naninoDoughCount:true,
        difference:true
      }
    });

    return {
      employeeId:id,
      performance:{
        sellingDoughCount:nanino._sum.sellingDoughCount || 0,
        naninoDoughCount:nanino._sum.naninoDoughCount || 0,
        difference:nanino._sum.difference || 0
      }
    };
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
