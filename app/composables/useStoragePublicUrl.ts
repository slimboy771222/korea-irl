export const useStoragePublicUrl = () => {
  const { $supabase } = useNuxtApp()

  const getPublicUrl = (bucket: string, path: string) =>
    $supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl

  return { getPublicUrl }
}
