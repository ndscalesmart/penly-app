import { AuthForm } from "@/components/auth-form";

// PENLY-001 / PENLY-002 — registration (email/password + Google OAuth)
export default function SignupPage() {
  return <AuthForm mode="signup" />;
}
