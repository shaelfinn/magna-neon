export default function DashboardPage() {
  return (
    <div className="min-h-screen bg-black text-white p-4">
      <div className="max-w-6xl mx-auto">
        <div className="flex justify-between items-center mb-8">
          <div className="flex items-center gap-4">
            <div>
              <h1 className="text-3xl font-bold">Dashboard</h1>
              <p className="text-gray-400">Welcome to your dashboard</p>
            </div>
          </div>
        </div>

        {/* Dashboard Content */}
        <div className="bg-gray-900/50 rounded-lg p-6 mb-8">
          <h2 className="text-xl font-semibold mb-4">Dashboard Content</h2>
          <p className="text-gray-400">
            This is your dashboard. Add your content here.
          </p>
        </div>
      </div>
    </div>
  );
}
