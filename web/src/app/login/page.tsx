import { AuthForm } from "@/components/auth-form";

// PENLY-001 / PENLY-002 — sign in (email/password + Google OAuth)
export default function LoginPage() {
  return <AuthForm mode="login" />;
}
