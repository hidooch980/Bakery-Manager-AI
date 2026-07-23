import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class BaleProvider {
  constructor(private http: HttpService) {}

  async sendMessage(chatId: string, message: string) {
    const token = process.env.BALE_BOT_TOKEN;

    if (!token) {
      throw new Error('BALE_BOT_TOKEN not configured');
    }

    const baseUrl = 'https://tapi.bale.ai/bot' + token;
    const url = baseUrl + '/sendMessage';

    const response = await firstValueFrom(
      this.http.post(url, {
        chat_id: chatId,
        text: message,
      }),
    );

    return response.data;
  }
}
