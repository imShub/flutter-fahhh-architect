export type HumorPhase = 'flutterCreate' | 'templateInject' | 'pubGet' | 'success' | 'error';

export type HumorMode = 'professional' | 'balanced' | 'chaotic';

type HumorMap = Record<HumorPhase, string[]>;

type HumorConfig = Record<HumorMode, HumorMap>;

const HUMOR_LINES: HumorConfig = {
	professional: {
		flutterCreate: [
			'Running flutter create...',
			'Scaffolding Flutter project...',
		],
		templateInject: [
			'Applying architecture template to lib/...',
			'Injecting prebuilt architecture into lib/...',
		],
		pubGet: [
			'Resolving Flutter dependencies...',
			'Running flutter pub get...',
		],
		success: [
			'Project scaffolding complete.',
			'Flutter app created successfully.',
		],
		error: [
			'An error occurred while creating the project.',
			'Operation failed. See details in the output.',
		],
	},
	balanced: {
		flutterCreate: [
			'Spinning up Flutter like it owes us rent...',
			'Assembling widgets and slightly better decisions...',
			'Drafting your app. Quietly judging your package name.',
			'Triggering flutter create—hold onto your imports.',
		],
		templateInject: [
			'Injecting SOLID principles into your project veins...',
			'Eliminating spaghetti code, one layer at a time...',
			'Deploying architecture like a senior who’s seen things...',
			'Swapping lib/ like nothing messy ever happened.',
		],
		pubGet: [
			'Asking pub.dev for yet another dependency...',
			'Negotiating with pub for fewer transitive regrets...',
			'Downloading packages and the occasional surprise...',
			'Running flutter pub get—package gods be kind.',
		],
		success: [
			'Fahhh injection complete 🚀',
			'Clean architecture deployed. Chaos politely escorted out.',
			'Mission accomplished. Go pretend it was easy.',
			'Your app is structured. Your feelings, maybe not.',
		],
		error: [
			'Plot twist: something exploded, but gracefully.',
			'Stack traces are just spicy documentation.',
			'Error achieved. Time to renegotiate with reality.',
			'The code blinked first. Investigating...',
		],
	},
	chaotic: {
		flutterCreate: [
			'Booting Flutter factory. Widgets are screaming.',
			'Spawning a fresh app universe. No pressure.',
			'flutter create engaged. May the types be ever in your favor.',
			'Drafting blueprints while Dart yawns in the background.',
		],
		templateInject: [
			'Air-dropping SOLID into your lib/ like a refactor strike team.',
			'Vaporizing spaghetti code and leaving clean layers behind.',
			'Attaching a tactical architecture pack to your project.',
			'Refitting lib/ with something your future self might actually respect.',
		],
		pubGet: [
			'Summoning the package swarm from pub.dev...',
			'Collecting dependencies like rare loot drops...',
			'flutter pub get: where optimism meets network latency.',
			'Pulling in packages and silently judging version ranges.',
		],
		success: [
			'Fahhh injection complete 🚀 Your app just leveled up.',
			'Clean architecture online. Spaghetti exiled to legacy.',
			'Everything compiled. Suspiciously smoothly, even.',
			'Your architecture is crisp. Go break it responsibly.',
		],
		error: [
			'Well, that escalated into an error quickly.',
			'The stack trace wrote a novel. We brought the bookmark.',
			'Something tripped over itself. Time to debug with dignity.',
			'The CLI disagreed with our life choices. Details in output.',
		],
	},
};

const lastLineByPhase: Partial<Record<HumorPhase, string>> = {};

export function getHumorLine(phase: HumorPhase, mode: HumorMode): string {
	const modeLines = HUMOR_LINES[mode] ?? HUMOR_LINES.balanced;
	const lines = modeLines[phase];
	if (!lines || lines.length === 0) {
		return '';
	}

	const last = lastLineByPhase[phase];
	const candidates = last ? lines.filter((l) => l !== last) : lines.slice();
	const pool = candidates.length > 0 ? candidates : lines;

	const index = Math.floor(Math.random() * pool.length);
	const chosen = pool[index];
	lastLineByPhase[phase] = chosen;
	return chosen;
}

