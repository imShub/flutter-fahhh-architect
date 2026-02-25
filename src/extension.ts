import * as vscode from 'vscode';
import * as path from 'path';
import { exec as execCb } from 'child_process';
import { promisify } from 'util';
import { getHumorLine, type HumorPhase, type HumorMode } from './humorEngine';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const fs: any = require('fs-extra');

const exec = promisify(execCb);

const COMMANDS = {
	createApp: 'flutterFahhhArchitect.createApp',
	support: 'flutterFahhhArchitect.support',
	// Back-compat with earlier manifest attempts (safe to keep).
	legacyCreateApp: 'flutter-fahhh-architect.createApp',
	legacySupport: 'flutter-fahhh-architect.support',
};

const BUY_ME_A_COFFEE_URL = 'https://www.buymeacoffee.com/';

type ArchitectureChoice = 'Clean Architecture' | 'MVVM';
type StateChoice = 'Riverpod' | 'Bloc' | 'Provider';

export function activate(context: vscode.ExtensionContext) {
	const output = vscode.window.createOutputChannel('Flutter Fahhh Architect');
	context.subscriptions.push(output);
	void showWelcomeIfFirstRun(context, output);

	const createAppHandler = async () => {
		await runCreateAppFlow({ context, output });
	};

	const supportHandler = async () => {
		await vscode.env.openExternal(vscode.Uri.parse(BUY_ME_A_COFFEE_URL));
	};

	context.subscriptions.push(
		vscode.commands.registerCommand(COMMANDS.createApp, createAppHandler),
		vscode.commands.registerCommand(COMMANDS.support, supportHandler),
		vscode.commands.registerCommand(COMMANDS.legacyCreateApp, createAppHandler),
		vscode.commands.registerCommand(COMMANDS.legacySupport, supportHandler),
	);
}

export function deactivate() {
	// nothing to cleanup
}

async function runCreateAppFlow(opts: { context: vscode.ExtensionContext; output: vscode.OutputChannel }) {
	const { context, output } = opts;

	try {
		const workspaceFolder = vscode.workspace.workspaceFolders?.[0]?.uri;

		const destinationUris = await vscode.window.showOpenDialog({
			title: 'Select a folder where the Flutter app will be created',
			canSelectFolders: true,
			canSelectFiles: false,
			canSelectMany: false,
			defaultUri: workspaceFolder,
			openLabel: 'Use this folder',
		});
		if (!destinationUris || destinationUris.length === 0) return;
		const destinationDir = destinationUris[0].fsPath;

		const appName = await askFlutterAppName();
		if (!appName) return;

		const architecture = await askArchitecture();
		if (!architecture) return;

		const stateManagement = await askStateManagement();
		if (!stateManagement) return;

		await vscode.window.withProgress(
			{
				location: vscode.ProgressLocation.Notification,
				title: `Flutter Fahhh: Creating ${appName}`,
				cancellable: true,
			},
			async (progress, token) => {
				const controller = new AbortController();
				token.onCancellationRequested(() => controller.abort());

				const projectDir = path.join(destinationDir, appName);

				progress.report({ message: 'Summoning Flutter CLI...' });
				output.show(true);
				output.appendLine(`[create] destination: ${destinationDir}`);
				output.appendLine(`[create] appName: ${appName}`);
				output.appendLine(`[create] architecture: ${architecture}`);
				output.appendLine(`[create] state: ${stateManagement}`);

				await ensureFlutterAvailable({ cwd: destinationDir, output, signal: controller.signal });

				progress.report({ message: 'Running flutter create...' });
				await runFlutterCreate({ appName, cwd: destinationDir, output, signal: controller.signal });

				progress.report({ message: 'Swapping in your Fahhh architecture...' });
				await replaceLibWithTemplate({
					context,
					projectDir,
					architecture,
					output,
					signal: controller.signal,
				});

				progress.report({ message: 'Merging pubspec dependencies...' });
				await updateProjectPubspec({
					projectDir,
					architecture,
					stateManagement,
					output,
					signal: controller.signal,
				});

				progress.report({ message: 'Running flutter pub get...' });
				await runFlutterPubGet({ cwd: projectDir, output, signal: controller.signal });

				console.log('Fahhh injection complete 🚀');
				progress.report({ message: 'Done.' });
			},
		);
	} catch (err) {
		await showErrorWithDetails('Failed to create Flutter Fahhh app.', output, err);
	}
}

async function askFlutterAppName(): Promise<string | undefined> {
	return vscode.window.showInputBox({
		title: 'Flutter app name',
		prompt: 'Enter a Flutter package name (lowercase_with_underscores)',
		placeHolder: 'my_fahhh_app',
		ignoreFocusOut: true,
		validateInput: (value) => {
			const name = value.trim();
			if (!name) return 'App name is required.';
			if (!/^[a-z][a-z0-9_]*$/.test(name)) return 'Use only lowercase letters, numbers, and underscores; must start with a letter.';
			if (name.endsWith('_')) return 'App name must not end with an underscore.';
			if (name.includes('__')) return 'Avoid double underscores.';
			return null;
		},
	});
}

async function askArchitecture(): Promise<ArchitectureChoice | undefined> {
	const config = vscode.workspace.getConfiguration('flutterFahhhArchitect');
	const defaultArch = config.get<ArchitectureChoice>('defaultArchitecture', 'Clean Architecture');
	const options: ArchitectureChoice[] =
		defaultArch === 'MVVM' ? ['MVVM', 'Clean Architecture'] : ['Clean Architecture', 'MVVM'];

	const picked = await vscode.window.showQuickPick(options, {
		title: 'Architecture type',
		placeHolder: 'Pick your flavor of maintainability',
		ignoreFocusOut: true,
	});
	return picked as ArchitectureChoice | undefined;
}

async function askStateManagement(): Promise<StateChoice | undefined> {
	const config = vscode.workspace.getConfiguration('flutterFahhhArchitect');
	const defaultState = config.get<StateChoice>('defaultStateManagement', 'Riverpod');
	const baseOptions: StateChoice[] = ['Riverpod', 'Bloc', 'Provider'];
	const options: StateChoice[] = [defaultState, ...baseOptions.filter((s) => s !== defaultState)];

	const picked = await vscode.window.showQuickPick(options, {
		title: 'State management',
		placeHolder: 'Pick your state weapon',
		ignoreFocusOut: true,
	});
	return picked as StateChoice | undefined;
}

async function ensureFlutterAvailable(opts: { cwd: string; output: vscode.OutputChannel; signal: AbortSignal }) {
	const { cwd, output, signal } = opts;
	try {
		logSection(output, 'Flutter Doctor');
		const res = await runCliCommand('flutter --version', { cwd, signal });
		if (res.stdout.trim()) {
			output.appendLine(res.stdout.trim());
		} else {
			output.appendLine('[flutter] OK');
		}
	} catch (e) {
		throw new Error('Flutter CLI not available. Please install Flutter and ensure `flutter` is on your PATH, then try again.', {
			cause: e as Error,
		});
	}
}

async function runFlutterCreate(opts: { appName: string; cwd: string; output: vscode.OutputChannel; signal: AbortSignal }) {
	const { appName, cwd, output, signal } = opts;
	const cmd = `flutter create ${quoteForShell(appName)}`;
	logSection(output, 'Flutter Create');
	output.appendLine(getHumor('flutterCreate'));
	output.appendLine(`[exec] ${cmd}`);

	try {
		const res = await runCliCommand(cmd, { cwd, signal });
		if (res.stdout) output.appendLine(res.stdout);
		if (res.stderr) output.appendLine(res.stderr);
	} catch (e) {
		output.appendLine(`[error] flutter create failed`);
		throw new Error(`flutter create failed for "${appName}".`, { cause: e as Error });
	}
}

async function replaceLibWithTemplate(opts: {
	context: vscode.ExtensionContext;
	projectDir: string;
	architecture: ArchitectureChoice;
	output: vscode.OutputChannel;
	signal: AbortSignal;
}) {
	const { context, projectDir, architecture, output, signal } = opts;

	if (signal.aborted) throw new Error('Operation cancelled.');

	const libDir = path.join(projectDir, 'lib');
	const templatesBase = path.join(context.extensionPath, 'templates');
	const templateRoot =
		architecture === 'Clean Architecture'
			? path.join(templatesBase, 'flutter-clean')
			: path.join(templatesBase, 'flutter-mvvm');
	const templateLibDir = path.join(templateRoot, 'lib');

	if (!(await fs.pathExists(projectDir))) {
		throw new Error(`Project folder not found at "${projectDir}". Did flutter create succeed?`);
	}

	if (!(await fs.pathExists(templatesBase))) {
		throw new Error(`Templates folder not found at "${templatesBase}". Ensure the extension is packaged with templates/ included.`);
	}

	if (!(await fs.pathExists(templateRoot))) {
		throw new Error(`Template root not found at "${templateRoot}". Expected templates for selected architecture.`);
	}

	if (!(await fs.pathExists(templateLibDir))) {
		throw new Error(
			`Template lib folder not found at "${templateLibDir}". Expected templates at "templates/flutter-clean/lib" or "templates/flutter-mvvm/lib".`,
		);
	}

	logSection(output, 'Template Injection');
	output.appendLine(getHumor('templateInject'));
	output.appendLine(`[template] using lib: ${templateLibDir}`);

	try {
		await fs.remove(libDir);
		await fs.ensureDir(libDir);
		await fs.copy(templateLibDir, libDir, {
			overwrite: true,
			errorOnExist: false,
			filter: (src: string) => {
				const base = path.basename(src).toLowerCase();
				return base !== '.ds_store';
			},
		});
	} catch (e) {
		throw new Error('Failed to replace lib/ with the selected template.', { cause: e as Error });
	}
}

async function updateProjectPubspec(opts: {
	projectDir: string;
	architecture: ArchitectureChoice;
	stateManagement: StateChoice;
	output: vscode.OutputChannel;
	signal: AbortSignal;
}) {
	const { projectDir, architecture, stateManagement, output, signal } = opts;
	if (signal.aborted) throw new Error('Operation cancelled.');

	const pubspecPath = path.join(projectDir, 'pubspec.yaml');
	if (!(await fs.pathExists(pubspecPath))) {
		throw new Error(`pubspec.yaml not found at "${pubspecPath}".`);
	}

	// Template defaults (kept for compilation safety).
	const templateDefault: StateChoice = architecture === 'Clean Architecture' ? 'Riverpod' : 'Provider';

	const wantedPkgs = new Set<string>();
	// Always-needed packages (both templates reference these).
	wantedPkgs.add('dio');
	wantedPkgs.add('audioplayers');
	wantedPkgs.add('url_launcher');
	// Localization delegates are used in both templates' main.dart.
	wantedPkgs.add('flutter_localizations');

	// Ensure template default is present; add selected if different.
	wantedPkgs.add(toStatePackage(templateDefault));
	if (stateManagement !== templateDefault) {
		wantedPkgs.add(toStatePackage(stateManagement));
	}

	const versions: Record<string, string> = {
		flutter_riverpod: '^2.6.1',
		provider: '^6.1.2',
		flutter_bloc: '^8.1.6',
		dio: '^5.7.0',
		audioplayers: '^6.1.0',
		url_launcher: '^6.3.0',
	};

	let text = (await fs.readFile(pubspecPath, 'utf8')) as string;
	// Normalize newlines for safer manipulation.
	text = text.replace(/\r\n/g, '\n');

	text = ensureYamlHasDependencies(text);
	text = ensureFlutterLocalizationsSdk(text);

	for (const pkg of wantedPkgs) {
		if (pkg === 'flutter_localizations') continue;
		const ver = versions[pkg];
		if (!ver) continue;
		text = ensureDependency(text, pkg, ver);
	}

	// Ensure sound assets are declared (files are referenced, not included).
	text = ensureFlutterAssets(text, 'assets/sounds/');

	await fs.writeFile(pubspecPath, text, 'utf8');
	output.appendLine(
		`[pubspec] ensured deps: ${Array.from(wantedPkgs)
			.map((p) => (p === 'flutter_localizations' ? 'flutter_localizations(sdk)' : p))
			.join(', ')}`,
	);

	// Helpful: create empty assets folder so the path exists (audio files still optional).
	await fs.ensureDir(path.join(projectDir, 'assets', 'sounds'));

	// Small hint when user picks a non-default state.
	if (stateManagement !== templateDefault) {
		output.appendLine(
			`[pubspec] note: template default is ${templateDefault}; also added ${stateManagement} dependency as requested.`,
		);
	}
}

async function runFlutterPubGet(opts: { cwd: string; output: vscode.OutputChannel; signal: AbortSignal }) {
	const { cwd, output, signal } = opts;
	const cmd = 'flutter pub get';
	logSection(output, 'Pub Get');
	output.appendLine(getHumor('pubGet'));
	output.appendLine(`[exec] ${cmd}`);

	try {
		const res = await runCliCommand(cmd, { cwd, signal });
		if (res.stdout) output.appendLine(res.stdout);
		if (res.stderr) output.appendLine(res.stderr);
	} catch (e) {
		output.appendLine('[error] flutter pub get failed');
		throw new Error('flutter pub get failed.', { cause: e as Error });
	}
}

function toStatePackage(state: StateChoice): string {
	switch (state) {
		case 'Riverpod':
			return 'flutter_riverpod';
		case 'Provider':
			return 'provider';
		case 'Bloc':
			return 'flutter_bloc';
	}
}

function ensureYamlHasDependencies(text: string): string {
	if (/^dependencies:\s*$/m.test(text)) return text;

	// Insert after environment: block if present; otherwise after name/description header.
	const envMatch = text.match(/^environment:\s*$[\s\S]*?(?=^\S|\s*$)/m);
	if (envMatch && envMatch.index !== undefined) {
		const insertAt = envMatch.index + envMatch[0].length;
		return `${text.slice(0, insertAt)}\n\ndependencies:\n  flutter:\n    sdk: flutter\n${text.slice(insertAt)}`;
	}

	return `dependencies:\n  flutter:\n    sdk: flutter\n\n${text}`;
}

function ensureFlutterLocalizationsSdk(text: string): string {
	// Ensure:
	//   flutter_localizations:
	//     sdk: flutter
	if (/^\s{2}flutter_localizations:\s*$/m.test(text) && /^\s{4}sdk:\s*flutter\s*$/m.test(text)) return text;

	if (/^\s{2}flutter_localizations:\s*$/m.test(text)) {
		// Has key but missing sdk.
		return text.replace(/^\s{2}flutter_localizations:\s*$/m, `  flutter_localizations:\n    sdk: flutter`);
	}

	// Insert right after "flutter:" sdk line in dependencies section when possible.
	const depFlutterSdk = /^dependencies:\s*$[\s\S]*?^\s{2}flutter:\s*$[\s\S]*?^\s{4}sdk:\s*flutter\s*$/m;
	if (depFlutterSdk.test(text)) {
		return text.replace(
			/^(\s{4}sdk:\s*flutter\s*)$/m,
			`$1\n  flutter_localizations:\n    sdk: flutter`,
		);
	}

	// Fallback: append under dependencies.
	return text.replace(/^dependencies:\s*$/m, `dependencies:\n  flutter_localizations:\n    sdk: flutter`);
}

function ensureDependency(text: string, packageName: string, version: string): string {
	const depLine = new RegExp(`^\\s{2}${escapeRegExp(packageName)}:\\s*`, 'm');
	if (depLine.test(text)) return text; // Already present (respect user's version).

	// Insert under dependencies (after flutter sdk + flutter_localizations if present).
	const depsBlock = /^dependencies:\s*$/m;
	if (!depsBlock.test(text)) return text;

	// Place after flutter_localizations if it exists, else after flutter sdk block, else right after dependencies:
	const locBlock = /^\s{2}flutter_localizations:\s*$[\s\S]*?^\s{4}sdk:\s*flutter\s*$/m;
	if (locBlock.test(text)) {
		return text.replace(locBlock, (m) => `${m}\n  ${packageName}: ${version}`);
	}

	const flutterSdkBlock = /^\s{2}flutter:\s*$[\s\S]*?^\s{4}sdk:\s*flutter\s*$/m;
	if (flutterSdkBlock.test(text)) {
		return text.replace(flutterSdkBlock, (m) => `${m}\n  ${packageName}: ${version}`);
	}

	return text.replace(/^dependencies:\s*$/m, `dependencies:\n  ${packageName}: ${version}`);
}

function ensureFlutterAssets(text: string, assetPath: string): string {
	const normalized = assetPath.endsWith('/') ? assetPath : `${assetPath}/`;

	// If already listed anywhere under flutter: assets:, no-op.
	const assetLine = new RegExp(`^\\s{4}-\\s+${escapeRegExp(normalized)}\\s*$`, 'm');
	if (assetLine.test(text)) return text;

	// Ensure flutter: section exists.
	if (!/^flutter:\s*$/m.test(text)) {
		return `${text.trimEnd()}\n\nflutter:\n  uses-material-design: true\n  assets:\n    - ${normalized}\n`;
	}

	// Ensure assets: exists within flutter:.
	if (!/^\s{2}assets:\s*$/m.test(text)) {
		// Prefer placing assets after uses-material-design if present.
		if (/^\s{2}uses-material-design:\s*true\s*$/m.test(text)) {
			return text.replace(
				/^\s{2}uses-material-design:\s*true\s*$/m,
				`  uses-material-design: true\n  assets:\n    - ${normalized}`,
			);
		}
		// Otherwise append assets block under flutter:
		return text.replace(/^flutter:\s*$/m, `flutter:\n  assets:\n    - ${normalized}`);
	}

	// assets: exists; append a new item under it.
	return text.replace(/^\s{2}assets:\s*$/m, `  assets:\n    - ${normalized}`);
}

function escapeRegExp(s: string) {
	return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function quoteForShell(value: string) {
	// Works for PowerShell/cmd/bash when used with shell:true (good enough for appName validation).
	return `"${value.replaceAll('"', '\\"')}"`;
}

function toErrorMessage(err: unknown): string {
	if (err instanceof Error) {
		const msg = err.message || 'Unknown error';
		const causeMsg = (err.cause instanceof Error && err.cause.message) || '';
		return causeMsg ? `${msg} (${causeMsg})` : msg;
	}
	if (typeof err === 'string') return err;
	try {
		return JSON.stringify(err);
	} catch {
		return 'Unknown error';
	}
}

async function showWelcomeIfFirstRun(context: vscode.ExtensionContext, output: vscode.OutputChannel): Promise<void> {
	const key = 'flutterFahhhArchitect.welcomeShown';
	const alreadyShown = context.globalState.get<boolean>(key);
	if (alreadyShown) return;

	await context.globalState.update(key, true);
	output.appendLine('==== Welcome ====');
	output.appendLine('Welcome to Flutter Fahhh Architect. We don\'t build apps. We build discipline.');
	await vscode.window.showInformationMessage(
		"Welcome to Flutter Fahhh Architect. We don't build apps. We build discipline.",
	);
}

async function showErrorWithDetails(
	message: string,
	output: vscode.OutputChannel,
	error?: unknown,
): Promise<void> {
	// Handle cancellation separately.
	if (isAbortError(error)) {
		output.appendLine('==== Cancelled ====');
		output.appendLine('Operation cancelled. No spaghetti was harmed.');
		await vscode.window.showInformationMessage('Flutter Fahhh: Cancelled. No spaghetti was harmed.');
		return;
	}

	output.appendLine('==== Error ====');
	output.appendLine(getHumor('error'));
	output.appendLine(`[error] ${message}`);
	if (error) {
		output.appendLine(`[error] Details: ${toErrorMessage(error)}`);
		if (error instanceof Error && error.stack) {
			output.appendLine(error.stack);
		}
	}

	const choice = await vscode.window.showErrorMessage(message, 'Show Details');
	if (choice === 'Show Details') {
		output.show(true);
	}
}

function getHumor(phase: HumorPhase): string {
	const config = vscode.workspace.getConfiguration('flutterFahhhArchitect');
	const mode = config.get<HumorMode>('humorMode', 'balanced');
	return getHumorLine(phase, mode);
}

function isAbortError(error: unknown): boolean {
	if (!(error instanceof Error)) return false;
	if (error.name === 'AbortError') return true;
	const msg = (error.message || '').toLowerCase();
	return msg.includes('aborted') || msg.includes('canceled') || msg.includes('cancelled');
}

function logSection(output: vscode.OutputChannel, title: string): void {
	output.appendLine(`==== ${title} ====`);
}

async function runCliCommand(
	command: string,
	opts: { cwd: string; signal: AbortSignal; timeoutMs?: number; maxBufferBytes?: number },
): Promise<{ stdout: string; stderr: string }> {
	const { cwd, signal, timeoutMs = 5 * 60_000, maxBufferBytes = 10 * 1024 * 1024 } = opts;
	try {
		const res = await exec(command, {
			cwd,
			signal,
			timeout: timeoutMs,
			maxBuffer: maxBufferBytes,
		} as any);

		const stdout = typeof res.stdout === 'string' ? res.stdout : res.stdout?.toString('utf8') ?? '';
		const stderr = typeof res.stderr === 'string' ? res.stderr : res.stderr?.toString('utf8') ?? '';

		// Normalize newlines for consistent logging.
		return {
			stdout: stdout.replace(/\r\n/g, '\n'),
			stderr: stderr.replace(/\r\n/g, '\n'),
		};
	} catch (err) {
		// Let callers decide how to surface; they will wrap with showErrorWithDetails.
		throw err;
	}
}
