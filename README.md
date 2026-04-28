# VAST Platform AI Assistant

This repository contains tools that support AI Assisted development in the [VAST platform](https://www.instantiations.com/vast-platform/) development environment. Use natural language to ask questions about the VAST code base and let the AI assist you in the development of VAST systems.

### Supported API Providers \& Models

The VAST Platform AI Assistant can connect to many different Large Language Models (LLMs).
Currently through one of two providers:

* *Gemini API Provider* allows access to [Google's Gemini AI](https://ai.google.dev/)
* *Responses API Provider* allows access to [OpenAI models](https://developers.openai.com/api/docs/models), as well as local and cloud models offered by any OpenAI-compatible provider, such as [Ollama](https://ollama.com/search), [LMStudio](https://lmstudio.ai/models), or [LiteLLM](https://www.litellm.ai/).

Only models supporting tools/function calling can be used with the AI Assistant. 
Thoughts/reasoning support is not required, but greatly enhances the experience.

![Gemini explaining initial configuration](/docs/images/ConfigurationQuery-Gemini.png)

### Quick Start

#### Prerequisites

* [VAST Platform](https://www.instantiations.com/vast-platform/) version 14.1 or later.
* OpenSSL libraries installed and [configured in VAST](https://www.instantiations.com/vast-support/documentation/FAQ/index.html#page/FAQ/va09002.html).

#### Install and Load

* Clone this repository.
* In VAST, **install the Tonel tools feature**. From the Transcript window, you can use the `Tools>>Load/Unload Features` menu item to load the `ST: Tonel Support` feature. We need [Tonel](https://www.instantiations.com/vast-support/documentation/1410/#page/sg/tonel/tnl01-index.519.01.html) to import the source code from this github repository into your local Envy library.
* From the Configuration Maps Browser, use the `Names>>Import>>Load Configuration Maps from Tonel Repository` menu item and point to the root directory of the local clone of the VAST Platform AI Assistant repository (which you cloned in the first step).
* In the window that opens, add only the config map for the `AI Assistant` that corresponds to your version of VAST (e.g. `AI Assistant (VAST 14.1.0)`) to the list of config maps to import and load.
* Once loaded, open `AI Assistant` from the Transcript window's `Tools` menu. Follow the next section to add your configuration.

#### Configure

* From the AI Assistant toolbar window, select Options->Settings. This opens the settings window showing the configured providers and models. To use the AI Assistant, at least one provider and a model must be configured.
* Select 'Providers' and either add an API key to one of the predefined cloud providers (e.g. Gemini), or press '+' and add the connection details for your preferred Responses API provider.
* Select 'Models' and add the models you want to use to the list. The available models for each provider will be shown automatically.
* If multiple models are configured, you can select which to use in the AI Assistant's Options->Model menu.
* You are ready to start asking questions!

#### Additional Configuration (optional)

* If you need to use an HTTP proxy, evaluate the following in a workspace with the correct URL for the proxy to set it in the global configuration for the ‘httpsl’ transport. See the class SstHttpConfiguration for methods for setting credentials for the proxy or a list of excepted domains, and the [section on ‘Configuring an HTTP Client to Use a Proxy’](https://www.instantiations.com/vast-support/documentation/1500/ss/sst89s.html) in the documentation for further details.

  ```smalltalk
  (SstTransport configurationForIdentifier: 'httpsl')
  	proxyUrl: 'https://proxy.local:8080' sstAsUrl
  ```

### Features Overview

The AI Assistant allows you to interact with multiple AI models directly from your VAST platform IDE. The AI model is connected to your development image and has access to all source code. In addition, you can supply additional information to the model by adding files to the conversation. This can be useful to, for example, share stack dumps with the AI when trying to analyze the origin of walkbacks.

#### Chat

Interact with the AI by typing in the bottom pane of the AI Assistant window and hit the 'send' button. The AI will write its response in the top pane of the window, with markdown rendered into user-friendly readable text.

When you use a model with thinking support, it is possible to display the thoughts by expanding the line that mentions 'Thoughts'.
![Thoughts entry for how to open a chat](/docs/images/Thoughts-Gemini.png)

#### Code

When the response includes Smalltalk source code, it is displayed with a vertical grey bar on the left. Clicking the grey bar will open an appropriate tool - for proposed changes to classes or methods, a merge tool, otherwise a Workspace.

<img src="./docs/images/MergeTool-Gemini.png" width=800 alt="Merge tool on suggested layout change">

#### Tools

The AI Assistant has access to a set of tools designed to help navigate, understand, and write code within the VAST Platform Smalltalk environment. If you want to know which ones these are, just ask "Can you list the available tools?".

![Available Tools](/docs/images/Tools-Gemini.png)

#### Files

Add files to the conversation via the toolbar menu and reference these in your conversation.

<img src="./docs/images/Files.png" width=250 height=250 alt="Dialog to attach file">

### Contributing
We encourage contributions!
Please check the guidelines in the [CONTRIBUTING](CONTRIBUTING.md) file.

### License

The source code is distributed under the Apache 2.0 license.
See the [LICENSE](LICENSE) file for details.

