import '../models/prompt_model.dart';

abstract final class PromptCatalog {
  static const items = <PromptModel>[
    PromptModel(
      id: 'carrying_today',
      text: 'What are you done carrying today?',
    ),
    PromptModel(
      id: 'leave_behind',
      text: 'What can you leave behind for tonight?',
    ),
    PromptModel(id: 'not_yours', text: 'What was never yours to carry?'),
    PromptModel(
      id: 'release_expectation',
      text: 'What expectation are you ready to release?',
    ),
    PromptModel(
      id: 'unsaid_words',
      text: 'What words do you not need to send?',
    ),
    PromptModel(
      id: 'small_weight',
      text: 'What small weight can you put down?',
    ),
    PromptModel(
      id: 'before_tomorrow',
      text: 'What do you not want to take into tomorrow?',
    ),
    PromptModel(
      id: 'old_story',
      text: 'What old story no longer needs your attention?',
    ),
    PromptModel(
      id: 'self_blame',
      text: 'What are you ready to stop blaming yourself for?',
    ),
    PromptModel(
      id: 'make_space',
      text: 'What would you like to make space for?',
    ),
    PromptModel(id: 'enough_for_today', text: 'What is enough for today?'),
    PromptModel(
      id: 'one_breath',
      text: 'What can wait until after one quiet breath?',
    ),
  ];
}
