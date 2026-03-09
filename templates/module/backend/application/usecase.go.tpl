package application

import "context"

type Create{{Entity}}UseCase struct {
	repo Repository
}

func (uc *Create{{Entity}}UseCase) Execute(ctx context.Context, input Create{{Entity}}Input) error {
	// TODO: implement business logic
	return nil
}
