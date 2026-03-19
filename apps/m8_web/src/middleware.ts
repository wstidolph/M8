import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs'
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export async function middleware(req: NextRequest) {
  const res = NextResponse.next()
  const supabase = createMiddlewareClient({ req, res })

  const {
    data: { session },
  } = await supabase.auth.getSession()

  // Protect dashboard routes
  // Note: For now, we allow the root "/" as it's the main creator page, 
  // but we might want to protect it if it contains sensitive author data.
  // The US1 says "Author Dashboard", which is usually the root in our case.
  
  if (!session && (req.nextUrl.pathname === '/' || req.nextUrl.pathname.startsWith('/dashboard'))) {
    const url = req.nextUrl.clone()
    url.pathname = '/auth'
    return NextResponse.redirect(url)
  }

  return res
}

export const config = {
  matcher: ['/', '/dashboard/:path*'],
}
