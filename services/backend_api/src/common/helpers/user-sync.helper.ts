import { SupabaseClient } from '@supabase/supabase-js';

export async function ensureUserExists(supabase: SupabaseClient, userId: string): Promise<void> {
  const { data } = await supabase
    .from('users')
    .select('id')
    .eq('id', userId)
    .single();

  if (!data) {
    await supabase.from('users').insert({
      id: userId,
      email: '',
      full_name: 'User',
      college: '',
      role: 'student',
    });
  }
}
