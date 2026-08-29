import { Injectable } from '@nestjs/common';
import { AppCacheService, CacheKeys, CacheTTL } from '../../common/cache/cache.service';

const DISPOSAL_TIPS: Record<string, string> = {
  plastic: 'Rinse and recycle in plastic recycling bin. Remove caps if different plastic type.',
  paper_cardboard: 'Recycle in paper/cardboard bin. Remove tape and staples. Flatten cardboard.',
  glass: 'Rinse and recycle in glass recycling bin. Separate by color if required.',
  metal: 'Rinse and recycle in metal recycling bin. Aluminum cans are highly recyclable.',
  organic: 'Compost in organic waste bin. Can be used for garden composting.',
  ewaste: 'Take to e-waste collection center. Do not dispose in regular trash.',
  textile: 'Donate wearable clothes. Textile recycling bins available at campus centers.',
  others: 'Check with campus waste management for proper disposal instructions.',
};

@Injectable()
export class DisposalService {
  constructor(private readonly cache: AppCacheService) {}

  async getTips(category: string): Promise<{ category: string; tips: string }> {
    const cacheKey = CacheKeys.disposal.tips(category);
    const cached = await this.cache.get<{ category: string; tips: string }>(cacheKey);
    if (cached) return cached;

    const tips = DISPOSAL_TIPS[category] ?? DISPOSAL_TIPS['others'];
    const result = { category, tips };
    await this.cache.set(cacheKey, result, CacheTTL.DISPOSAL);
    return result;
  }

  async getAllTips(): Promise<Record<string, string>> {
    const cacheKey = CacheKeys.disposal.all();
    const cached = await this.cache.get<Record<string, string>>(cacheKey);
    if (cached) return cached;

    await this.cache.set(cacheKey, DISPOSAL_TIPS, CacheTTL.DISPOSAL);
    return DISPOSAL_TIPS;
  }
}
